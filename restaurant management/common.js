
function displayMsg(msg) {
    $msg = $(".message-box");
    $msg.show();
    $msg.html(`<h4>${msg}</h4>`);
    setTimeout(() => {
        $msg.hide();
    }, 2000);
}

