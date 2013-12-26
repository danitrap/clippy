$(document).ready(function() {

    var updateCounter = function() {
        var num = parseInt($('.countdown').text());
        $('.countdown').text(--num);
        setTimeout(updateCounter, 1000);
    };

    updateCounter();

});