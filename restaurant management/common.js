
function displayMsg(msg) {
    $msg = $(".message-box");
    $msg.show();
    $msg.html(`<h4>${msg}</h4>`);
    setTimeout(() => {
        $msg.hide();
    }, 2000);
}

function callajax(type, url, data, callback) {
    $.ajax({
        type: type,
        url: url,
        data: data,
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        success: function (data) {
            if (data.d) {
                console.log(data.d);
                callback(data.d);
            }

        },
        error: function (err) {
            alert("Error occured");
        }
    });
}

function getdatacallajax(type, url, callback) {
    $.ajax({
        type: type,
        url: url,
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        success: function (data) {
            if (data.d) {
                console.log(data.d);
                callback(data.d);
            }

        },
        error: function (err) {
            alert("Error occured");
        }
    });
}