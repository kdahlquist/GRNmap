$(function () {
    $.getJSON("http://grnsight.cs.lmu.edu/beta/server/grnmap?path=" + location.pathname.split("/").pop(), function (result) {
        
        if(location.pathname.split("/").pop() === "downloads.html") {
            $.getJSON("http://grnsight.cs.lmu.edu/beta/server/grnmap?path=download", function (uploadCount) {
                $(".ga-download").text(downloadCount);
            })
        }
        
        $(".ga-report").text(result);
        
    });
});
