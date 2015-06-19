$(function () {
    var pathTail = location.pathname.split("/").pop();
    $.getJSON("http://grnsight.cs.lmu.edu/beta/server/grnmap?path=" + pathTail, function (result) {
        
        if (pathTail === "downloads.html") {
            var exec = $('div[id$="_executable"]');
            var source = $('div[id$="_source"]');

            exec.each(function (index, element) {
                var $exec = $(element);
                $.getJSON("http://grnsight.cs.lmu.edu/beta/server/grnmap?path=download/" + $exec.attr('id'), function (execDownloadCount) {
                    $exec.find(".ga-execDownload").text(execDownloadCount);
                });
            });

            source.each(function (index, element) {
                var $source = $(element);
                $.getJSON("http://grnsight.cs.lmu.edu/beta/server/grnmap?path=download/" + $source.attr('id'), function (sourceDownloadCount) {
                    $source.find(".ga-sourceDownload").text(sourceDownloadCount);
                });
            });            
        }

        $(".ga-report").text(result);

    });
});
