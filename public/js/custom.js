$(document).ready(function() {

    $('.bookmark').hover(function() {
        self = $(this);
        self.select();
    });

    var updateCounter = function() {
        var num = parseInt($('.countdown').text());
        if (num === 0) {
            location.href = "/";
        }
        $('.countdown').text(--num);
        setTimeout(updateCounter, 1000);
    };

    updateCounter();

});