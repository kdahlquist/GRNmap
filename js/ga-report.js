$(function () {
    var pathTail = location.pathname.split("/").pop();

    var updateTotal = function ($total, subtotal) {
            var current = +$total.text();
            $total.text(current + subtotal);
        };

    var retrieveVersionCount = function ($container, subselector, $total) {
            $.getJSON(
                "http://grnsight.cs.lmu.edu/beta/server/grnmap?path=download/" + $container.attr('id'),
                function (count) {
                    $container.find(subselector).text(count);
                    updateTotal($total, +count);
                }
            );
        };

    $.getJSON("http://grnsight.cs.lmu.edu/beta/server/grnmap?path=" + pathTail, function (result) {
        
        if (pathTail === "downloads.html") {
            var $execTotal = $(".executable-total"),
                $sourceTotal = $(".source-total");

            $('div[id$="_executable"]').each(function (index, element) {
                retrieveVersionCount($(element), ".ga-execDownload", $execTotal);
            });

            $('div[id$="_source"]').each(function (index, element) {
                retrieveVersionCount($(element), ".ga-sourceDownload", $sourceTotal);
            });            
        }

        $(".ga-report").text(result);
    });
});
