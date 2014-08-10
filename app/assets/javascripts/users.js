$(function() {
  $('.interest_level').each(function() {
    var interest_level = this;
    var interest_percentage = $(this).data("interest-percentage");
    var radial_interest_progress = d3.select(interest_level);

    start();

    function start() {

      var radial_interest_progression = radialProgress(interest_level)
            .label("Current Interest Level")
            .diameter(200)
            .value(interest_percentage)
            .render();
    }
  });
});


