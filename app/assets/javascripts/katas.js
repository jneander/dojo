var DojoTables = function() {
  function enableDT() {
    $('table.clickable_rows > tbody > tr').
      addClass('clickable').
      click(function(){
        window.location = $(this).attr('data-href');
      }).find('a').hover( function() { 
        $(this).parents('tr').unbind('click'); 
      }, function() { 
        $(this).parents('tr').click( function() { 
          window.location = $(this).attr('data-href'); 
        }); 
      });
  }

  return {
    enable: enableDT,
  };

}();

$(document).ready(function() {
  DojoTables.enable();
});
