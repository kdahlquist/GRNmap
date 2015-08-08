$(function () {
    $.getJSON(
        "http://grnsight2.cs.lmu.edu/server/grnmap?path=" + location.pathname.split("/").pop(),
        function (result) {
            $(".ga-report").text(result);
        }
    );
});
