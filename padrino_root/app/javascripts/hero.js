var $ = require('jquery');

var HERO_ELEMENT_SELECTOR = '.hero'

function init() {
  $(window).on('load', fillViewportHeight);
};

function fillViewportHeight() {
  // detect browser dimensions onload, and resize hero image section to fit
  $(HERO_ELEMENT_SELECTOR).css({ height: $(window).height() });
};

exports.init = init;
