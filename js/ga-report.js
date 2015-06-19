$(function () {
    var pathTail = location.pathname.split("/").pop();

    var retrieveVersionCount = function ($container, subselector) {
            $.getJSON(
                "http://grnsight.cs.lmu.edu/beta/server/grnmap?path=download/" + $container.attr('id'),
                function (count) {
                    $container.find(subselector).text(count);
                }
            );
        };

    $.getJSON("http://grnsight.cs.lmu.edu/beta/server/grnmap?path=" + pathTail, function (result) {
        
        if (pathTail === "downloads.html") {
            $('div[id$="_executable"]').each(function (index, element) {
                retrieveVersionCount($(element), ".ga-execDownload");
            });

            $('div[id$="_source"]').each(function (index, element) {
                retrieveVersionCount($(element), ".ga-sourceDownload");
            });            
        }

        $(".ga-report").text(result);
    });
});
