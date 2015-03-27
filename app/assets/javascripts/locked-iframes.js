/*
 * Loads IFrames only after a trigger has been clicked.
 *
 * The trigger must have the class "unlock-iframe-trigger"
 * and the attribute data-target-frame = #ID of frame.
 * The frame must have the class "unlock-iframe", the ID mentioned above,
 * and the src attribute must be renamed to data-frame-src.
 **/
$(document).ready(function() {
    $('.locked-iframe-trigger').click(function() {
        $($(this).data('target-frame')).each(function() {
            $(this).removeClass('locked-iframe').attr({src: $(this).data('frame-src')});
        });
        $(this).hide();
    });
});