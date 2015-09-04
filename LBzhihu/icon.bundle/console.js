(function() {
    var output = document.createElement('div');
    document.body.appendChild(output);
    var textarea = document.createElement('textarea');
    document.body.appendChild(textarea);
    var btn = document.createElement('button');
    $(textarea).css('width', '300px');
    $(textarea).css('min-height', '300px');
    $(textarea).css('margin', ' 5px 5px');
    textarea.setAttribute('autocorrect', 'off');
    textarea.setAttribute('autoautocapitalize', 'off');
    $(btn).text('Run');
    $(btn).css('font-size', '1.3em');
    $(btn).css('display', 'block');
    $(btn).css('width', '100px');
    $(btn).css('height', '100px');
    document.body.appendChild(btn);
    var log = function(text, warning) {
        var line = document.createElement('div');
        $(line).text(text);
        if (warning) {
            $(line).css('color', '#FF5555');
        }
        output.appendChild(line);
    };
    console.log = log;
    $(btn).click(function() {
        try {
            (function() {
                var result = eval($(textarea).val());
                log(result);
            }).call(window);
        } catch (e) {
            log(e, true);
        }
        $(textarea).focus();
        window.scrollTo(0, 99999);
    });
    $(textarea).focus();
})();