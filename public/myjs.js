function addStyle (style, word) {
  $('.ppi-code .word').each(function(){
    e = $(this);
    if (e.text() === word) {
      e.removeClass('word').addClass(style);
    }
  });
}

$(function(){
  addStyle('keyword', 'class');
  addStyle('keyword', 'library');
  addStyle('keyword', 'method');
  addStyle('keyword', 'has');
  addStyle('type', 'Article');
  addStyle('type', 'Coordinate');
  addStyle('type', 'Force');
  addStyle('type', 'Simulator');
  addStyle('type', 'Num');
  addStyle('type', 'ArrayRef');
  addStyle('type', 'CodeRef');
});
