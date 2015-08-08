$(function () {
    $.getJSON(
        "http://grnsight2.cs.lmu.edu/beta/server/grnmap?path=" + location.pathname.split("/").pop(),
        function (result) {
            $(".ga-report").text(result);
        }
    );
});
