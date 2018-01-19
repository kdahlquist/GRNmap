$(function() {

    $(window).scroll(function() {
        // This prevents the side bar from staying stuck when the user has scrolled left. Also, when the user would zoom
        // in, the sidebar would stay stuck. This prevents that.
        if( ($(window).scrollLeft() >= 30 && $(window).scrollTop() > 140) || ($(window).scrollTop() < 140 &&  $("#stickyBar").attr('class') != 'affix-top') ) {
            $("#stickyBar").attr('class', 'affix-top');
        // Re-sticks the sidebar after being unstuck due to left scroll.
            } else if($(window).scrollTop() > 140 && $("#stickyBar").attr('class') != 'affix') {
            $("#stickyBar").attr('class', 'affix');
        } 
    })

    var setupClickableItems = function (clickableSelector, contentId, targetHref) {
        // Documentation page only: Makes links open their respective sections when clicked
        $(contentId).on('shown.bs.collapse', function () {
            window.location.href = targetHref;
        });
        
        // If the links are already open, the above handlers won't fire, so we force the page to change in that case
        // Using .on because using .click doesn't work for some reason
        $(clickableSelector).on('click', function () {
            $(contentId).collapse('show');
            if($(contentId).attr('class') === 'panel-collapse collapse in') {
                window.location.href = targetHref;
            };
        });
    };

    [
        [ '.showSection2', '#section2Content', '#section2' ],
        [ '.showSection3', '#section3Content', '#section3' ]
    ].forEach(function (clickableItem) {
        setupClickableItems.apply(null, clickableItem);
    });

    // Change the modified time of the web page
    $( "#modified").html( document.lastModified );

    // Enable logo change on-hover
    $( "#GRNsightLogo" ).on( "mouseenter", function() {
    	$("#GRNsightLogo").attr("src", "images/GRNsight_logo_20140710_rollover_resized.jpg")
    })
                .on("mouseleave", function() {
    	$("#GRNsightLogo").attr("src", "images/GRNsight_logo_20140710_main_resized.jpg")
    });

    // Open a hashed element if it is collapsed. This is a little trickier than it sounds,
    // because then we also have to open any parents that are also collapsed.
    if (location.hash) {
        var $elementToOpen = $(location.hash);
        if ($elementToOpen.is('.collapse:not(.in)')) {
            $elementToOpen.parents('.collapse:not(.in)').collapse('show');
            $elementToOpen.collapse('show');
        }
    }
    // Same code as GRNSight's function to display the cookie banner
    
    var PRIVACY_COOKIE = "_grnsight_privacy_";
    var checkForPrivacyCookie = function () {
        // Thank you http://stackoverflow.com/questions/4825683/how-do-i-create-and-read-a-value-from-cookie
        var createCookie = function (name, value, days) {
            var expires = "";
            if (days) {
                var date = new Date();
                date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
                expires = "; expires=" + date.toGMTString();
            }

            document.cookie = name + "=" + value + expires + "; path=/";
        };

        var getCookie = function (name) {
            if (document.cookie.length > 0) {
                var cookieStart = document.cookie.indexOf(name + "=");
                if (cookieStart !== -1) {
                    cookieStart = cookieStart + name.length + 1;
                    var cookieEnd = document.cookie.indexOf(";", cookieStart);
                    if (cookieEnd === -1) {
                        cookieEnd = document.cookie.length;
                    }
                    return unescape(document.cookie.substring(cookieStart, cookieEnd));
                }
            }

            return "";
        };

        if (!getCookie(PRIVACY_COOKIE)) {
            $("#cookie-notice").removeClass("hidden");
            createCookie(PRIVACY_COOKIE, "shown", 3650);
        }
    };
    
    checkForPrivacyCookie();
})
