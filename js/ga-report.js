$(function () {
    $.getJSON("http://grnsight.cs.lmu.edu/beta/server/grnmap?path=" + location.pathname.split("/").pop(), function (result) {
        
        if (location.pathname.split("/").pop() === "downloads.html") {
            var exec = $(this.attr('class')).closest('div[id$="_executable"]').attr('id');
            var source = $(this.attr('class')).closest('div[id$="_source"]').attr('id');
            $.getJSON("http://grnsight.cs.lmu.edu/beta/server/grnmap?path=download" + "/" + exec, function (execDownloadCount) {
                $(".ga-execDownload").text(execDownloadCount);
            })
            $.getJSON("http://grnsight.cs.lmu.edu/beta/server/grnmap?path=download" + "/" + source, function (sourceDownloadCount) {
                $(".ga-sourceDownload").text(sourceDownloadCount);
            })
        }

        $(".ga-report").text(result);
        
    });
});
