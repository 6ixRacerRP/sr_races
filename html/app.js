$("document").ready(function() {

    window.addEventListener("message", function(e) {
        var item = event.data;
        if (item.ui === "raceui") {
            if (item.status == true) {
                $("#container").toggleClass("hidden");
            }  
        }
    })

    $("#newrace").click(function() {
        $.post("http://sr_races/new_race", JSON.stringify({}));
    })

    document.onkeyup = function(data) {
        if (data.which == 27) { //ESC Key
            $("#container").toggleClass("hidden");
            $.post("http://sr_races/NUIFocusOff", JSON.stringify({}));
        }
    }
})