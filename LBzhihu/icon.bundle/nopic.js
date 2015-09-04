(function () {
    window.reload_last_img = function () {
        if (window.last_clicked_img) {
            var img = window.last_clicked_img;
            if (img.style.display == 'none') {
                var placeholder = img.parentElement;
                placeholder.removeChild(img);
                placeholder.parentElement.insertBefore(img, placeholder);
                placeholder.parentElement.removeChild(placeholder);
                img.style.display = '';
                var url = img.getAttribute('src');
                img.setAttribute('src', url);
                return 'a';
            }
            return 'b';
        }
        return 'c';
    };

    window.img_click = function (img) {
        if (img.className.indexOf('avatar') >= 0) {
            return;
        }
        window.last_clicked_img_url = img.src;
        window.last_clicked_img = img;
        window.location = "zhihunews:loadimg";
    };

    window.img_error = function (img) {
        if (img.className.indexOf('avatar') >= 0) {
            return;
        }
        var placeholder = document.createElement('div');

        if (document.body.className.indexOf('night') >= 0) {
            placeholder.setAttribute('style', 'width: 280px; height: 185px; line-height:185px; text-align:center; background: #2b2b2b; font-size: 0.8em; color: #444444');
        } else {
            placeholder.setAttribute('style', 'width: 280px; height: 185px; line-height:185px; text-align:center; background: #f6f6f6; font-size: 0.8em; color: #dadada');
        }
        placeholder.style.margin = '10px 0';
        var data_height = +img.getAttribute('data-height');
        if (data_height) {
            var data_width = +img.getAttribute('data-width');
            if (data_width > 280) {
                data_height = data_height * 280 / data_width;
                data_width = 280;
            }
            placeholder.style.height = data_height + 'px';
            placeholder.style.width = data_width + 'px';
        }
        placeholder.setAttribute('onclick', 'img_click(this.getElementsByTagName("img")[0])');
        placeholder.innerText = "点击下载此图片";
        img.parentElement.insertBefore(placeholder, img);
        img.parentElement.removeChild(img);
        img.style.display = 'none';
        placeholder.appendChild(img);
    };

    window.set_night_mode = function(enabled) {
        if (enabled) {
            $('body').addClass('night');
        } else {
            $('body').removeClass('night');
        }
    };
    window.update = function(info) {
        if (!info) return;
        var $theme;
        if (info.theme && info.theme.id && info.theme.name && info.theme.thumbnail) {
            $theme = $('<div class="origin-source-wrap"><a class="origin-source with-link" href="zhihudaily://theme/' + info.theme.id + '"><img src="' + info.theme.thumbnail + '" class="source-logo"><span class="text">本文来自：' + info.theme.name + '</span></a><a class="focus-link" href="javascript:;"><span class="btn-label">关注</span></a></div>').appendTo($(".question").last());
        } else if (info.section && info.section.id && info.section.name && info.section.thumbnail) {
            $(".question").last().append('<div class="origin-source-wrap unfocused"><a class="origin-source with-link" href="zhihudaily://section/' + info.section.id + '"><img src="' + info.section.thumbnail + '" class="source-logo"><span class="text">本文来自：' + info.section.name.replace(/#/g, "") + ' · 合集</span></a></div>');
        }
        if (info.theme.id) {
            setTimeout(function(){
                var shouldShowHUD = false;
                var active_click = true;
                if (window.daily) {
                    $theme.find('a.focus-link').on('click', function() {
                        if (!active_click) return;
                        active_click = false;
                        shouldShowHUD = true;
                        window.daily.execCommand('themes/add ' + info.theme.id);
                        window.daily.sendGAEventWithCategoryActionLabel('Click', "Follow on Story Bottom", info.theme.name);
                    });
                    $theme.find('a.with-link').on('click', function() {
                        window.daily.sendGAEventWithCategoryActionLabel('Click', "Theme on Story Bottom", info.theme.name);
                        return true;
                    });
                    window.dailyHandleEvent = function(event) {
                        switch (event.eventName) {
                            case "theme action failed":
                                active_click = true;
                                if (event.command == 'themes/add ' + info.theme.id) {
                                    if (shouldShowHUD) {
                                        shouldShowHUD = false;
                                        window.daily.showHUD('关注失败');
                                    }
                                } else if (event.command == 'themes/remove ' + info.theme.id) {
                                    shouldShowHUD = false;
                                }
                                break;
                            case "theme action success":
                                active_click = true;
                                if (event.command == 'themes/add ' + info.theme.id) {
                                    $theme.removeClass('unfocused');
                                    if (shouldShowHUD) {
                                        shouldShowHUD = false;
                                        window.daily.showHUD('关注成功');
                                    }
                                } else if (event.command == 'themes/remove ' + info.theme.id) {
                                    shouldShowHUD = false;
                                    $theme.addClass('unfocused');
                                }
                                break;
                            case "themes subscribed updated":
                                var themes = event.data.subscribed;
                                for (var i = 0; i < themes.length; i++) {
                                    if (themes[i] == info.theme.id) {
                                        $theme.removeClass('unfocused');
                                        return;
                                    }
                                }
                                $theme.addClass('unfocused');
                        }
                    };
                    window.daily.execCommand('themes/subscribed');
                }
            }, 100);
        }
    };
})();