$(function () {
    $.getJSON(
        "http://grnsight.cs.lmu.edu/server/grnmap?path=" + location.pathname.split("/").pop(),
        function (result) {
            $(".ga-report").text(result);
        }
    );
});
