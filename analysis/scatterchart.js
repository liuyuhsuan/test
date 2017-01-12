 
var h = 450;
var w = h;
var pad = {left: 70, top: 60, right: 5, bottom: 105, middle: 120 };
var corrInnerPad = 1;
var scatInnerPad = 10;
var radius = 8;
var highlightRadius = 12
var brushRadius = 7;
var colors = {  
                "group1": "crimson", 
                "group2": "green", 
                "group3": "darkslateblue"
              };




  var margin = {top: 20, right: 15, bottom: 60, left: 60}
      , width = 960 - margin.left - margin.right
      , height = 500 - margin.top - margin.bottom;

  var chart = d3.select('#mainChart')
  .append('svg:svg')
  .attr('width', width + margin.right + margin.left)
  .attr('height', height + margin.top + margin.bottom)
  .attr('class', 'chart')

  var main = chart.append('g')

  .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
  .attr('width', width)
  .attr('height', height)
  .attr('class', 'main')  


 d3.csv("https://ndshen.github.io/test/analysisword.csv", scatter);
  function scatter(data){
    
    var x = d3.scale.linear()
              .domain([0, d3.max(data, function(d) { return d["rating"]; })])
              .range([ 0, width ]);
    
    var y = d3.scale.linear()
            .domain([0, d3.max(data, function(d) { return d["pop"]; })])
            .range([ height, 0 ]);
 
      
  
        
    // draw the x axis
    var xAxis = d3.svg.axis()
  .scale(x)
  .orient('bottom');

    main.append('g')
  .attr('transform', 'translate(0,' + height + ')')
  .attr('class', 'main axis date')
  .call(xAxis);

    // draw the y axis
    var yAxis = d3.svg.axis()
  .scale(y)
  .orient('left');

    main.append('g')
  .attr('transform', 'translate(0,0)')
  .attr('class', 'main axis date')
  .call(yAxis);

    var g = main.append("svg:g")
                .attr("id", "scatPlot"); 
    
    g.selectAll("scatter-dots")
      .data(data)
      .enter().append("svg:circle")
          .attr("class", "points")
          .attr("cx", function (d,i) { return x(d["rating"]); } )
          .attr("cy", function (d) { return y(d["pop"]); } )
          .attr("r", 8);
    g.selectAll(".points")
          .on("mouseover", scatOverEvent)
          .on("mouseout", scatOutEvent);
  }
  ////////////////////////////////////////
  //  ADD SCATTER PLOT EVENT HANDLERS  ///
  ////////////////////////////////////////

  //highlight the currently selected point
  var highlightPoint = function() {

    //change the colors of all the points
    main.selectAll(".points").style("fill", "grey")

    //point and position of current selection 
    var d = this.datum();
    var pos  = { x: +this.attr("cx"), y: +this.attr("cy") };

    //enlarge the radius and change the color
    this.moveToFront()
        .attr("r", highlightRadius);
  };

  //handler for hovering over a scatter point
  var scatOverEvent = function() {

    

    //highlight the current point
    var point = d3.select(this);
    point.call(highlightPoint);
    point.style("fill", "yellow")
    //display the tooltip
    var id = point.datum().id;
    console.log(id);
    var pos  = { x: +point.attr("cx"), y: +point.attr("cy") };
    d3.select("#scatTooltip")
      .style("display", "block")
      .select(".value")
      .text(id);
  };

  //handler for leaving a scatter point (restore radius, hide tooltip)
  var scatOutEvent = function() {

    //hide tooltip
    d3.select("#scatTooltip")
      .style("display", "none");

    //reset attributes of current data point
    var point = d3.select(this);
    point.attr("r", radius);
    if (point.classed("insideBrush")) point.attr("r", brushRadius);

    //reset colors of other data points
    main.selectAll(".points")
            .style("fill", function(d) {return colors[d.group];});
  };

  //helper function for moving elements to the front
d3.selection.prototype.moveToFront = function() {
  return this.each(function(){
    this.parentNode.appendChild(this);
  });
};
d3.transition.prototype.moveToFront = function() {
  return this.each(function(){
    this.parentNode.appendChild(this);
  });
};
  