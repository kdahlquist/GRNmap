$(function () {
    $.getJSON(
        "http://grnsight.cs.lmu.edu/beta/server/grnmap?path=" + location.pathname.split("/").pop(),
        function (result) {
            $(".ga-report").text(result);
        }
    );
});
