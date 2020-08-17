$("document").ready(function() {

    window.addEventListener("message", function(event) {
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
            $("#mainmenu").toggleClass("hidden");
        })

    // Load Race button
    $("#loadrace").click(function() {
        $.post("http://sr_races/load_races", JSON.stringify({}));
        window.addEventListener("message", function(event) {
            var item = event.data;
            if (item.ui === "loadraces") {
                var raceNames = $.parseJSON(item.raceNames);
                for (i = 0; i < raceNames.length; i++) {
                    var name = "<p><b>" + raceNames[i] + "</b></p>";
                    var singleraceui = "<div>" + name + "<button id=\"loadspecific\">Load This</button><button id=\"deletespecific\">Delete</button></div>"
                    $("#loadracemenu").prepend(singleraceui)
                }
            }
        })
        $("#mainmenu").toggleClass("hidden");
        $("#loadracemenu").toggleClass("hidden");
    })

        // Load specific race button
        $("#loadspecific").live('click', function(){
            var name = $(this).prev().html();
            console.log(name);
        })

        // Delete specific race button
        $("button:contains('Delete')").click(function(){
            
        })

        // Cancel button
        $("#loadracecancel").click(function(){
            $("#loadracemenu").toggleClass("hidden");
            $("#mainmenu").toggleClass("hidden");
            $("#loadracemenu").html("<div><button id=\"loadracecancel\">Cancel</button></div>")
        })

    $("#exit").click(function() {
        $("#mainmenu").toggleClass("hidden");
        $.post("http://sr_races/NUIFocusOff", JSON.stringify({}));
    })

    document.onkeyup = function(data) {
        if (data.which == 27) { //ESC Key
            $("#container").toggleClass("hidden");
            $.post("http://sr_races/NUIFocusOff", JSON.stringify({}));
        }
    }
})