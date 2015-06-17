$(function () {
    $.getJSON("http://grnsight.cs.lmu.edu/server/beta/grnmap?path=" + location.pathname.split("/").pop(), function (result) {
        $(".ga-report").text(result);
    });
});
