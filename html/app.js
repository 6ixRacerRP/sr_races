$("document").ready(function() {

    window.addEventListener("message", function(e) {
        var item = event.data;
        if (item.ui === "raceui") {
            if (item.status == true) {
                $("#mainmenu").toggleClass("hidden");
            }  
        }
    })
    
    // New Race button
    $("#newrace").click(function() {
        $("#mainmenu").toggleClass("hidden");
        $("#newracemenu").toggleClass("hidden");
        $.post("http://sr_races/new_race", JSON.stringify({}));
    })

        // Save button
        $("#newracesave").click(function() {
            var name_val = $("#newracename").val()
            var laps_val = $("#newracelaps").val()

            if (name_val === "" || !$.isNumeric(laps_val)) {
                $.post("http://sr_races/invalid_input")
            } else {
                $("#newracemenu").toggleClass("hidden");
                $("#mainmenu").toggleClass("hidden");
                $.post("http://sr_races/save_race", JSON.stringify({
                    name    : name_val,
                    laps    : laps_val
                }));
            }
        })

        // Cancel button
        $("#newracecancel").click(function() {
            $("#newracemenu").toggleClass("hidden");
            $.post("http://sr_races/NUIFocusOff", JSON.stringify({}));
        })

    // Load Race button
    $("#loadrace").click(function() {
        // load race button clicked
    })

    document.onkeyup = function(data) {
        if (data.which == 27) { //ESC Key
            $("#container").toggleClass("hidden");
            $.post("http://sr_races/NUIFocusOff", JSON.stringify({}));
        }
    }
})