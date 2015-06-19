$(function () {
    var updateTotal = function ($total, subtotal) {
            $total.text(+$total.text() + subtotal);
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

    $('div[id$="_executable"]').each(function (index, element) {
        retrieveVersionCount($(element), ".ga-execDownload", $(".executable-total"));
    });

    $('div[id$="_source"]').each(function (index, element) {
        retrieveVersionCount($(element), ".ga-sourceDownload", $(".source-total"));
    });            
});
