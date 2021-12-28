
function show_data(datalist, ticks) {
	const SVG_HEIGHT = 400;    //常量
	const SVG_WIDTH = 500;     //常量
	const MARGIN = { TOP: 30, RIGHT: 30, LEFT: 30, BOTTOM: 30 } //间距

	var container = d3.select("#app");

	//序数比例尺    宽度计算
	const xScale = d3.scaleBand()
	  .domain(d3.range(datalist.length)) //[0,1,2,3,4]
	  .range([0, SVG_WIDTH - MARGIN.LEFT - MARGIN.RIGHT])
	  .paddingInner(0.1)    //每个柱之间的横向间隙

	//线性比例尺   高度计算
	const yScale = d3.scaleLinear()
	  .domain([0, d3.max(datalist)])
	  .range([SVG_HEIGHT - MARGIN.TOP - MARGIN.BOTTOM, 0])

	//水平方向坐标轴
	var axisBottom = d3.axisBottom(xScale)
	//  container.append('g').call(axisBottom)
	axisBottom(
	  container.append('g')
		.attr('class', 'xaxis')
		.attr("transform", `translate(${MARGIN.LEFT},${SVG_HEIGHT - MARGIN.TOP})`)
	)

	//垂直方向坐标轴
	var axisLeft = d3.axisLeft(yScale)
	axisLeft(
	  container.append("g")
		.attr("transform", `translate(${MARGIN.LEFT},${MARGIN.TOP})`)
	)

	//更新水平方向tick值
	d3.select('.xaxis').selectAll('text').data(ticks)
	  .text((d) => {
		return d;
	  })

	container.selectAll('rect')   //寻找rect标签
	  .data(datalist)           //绑定数据源
	  .enter()
	  .append('rect')         //添加rect标签
	  // .attr('class','bar')
	  .classed('bar', true)     //样式名
	  .attr('x', function (d, i) {         //x坐标
		return xScale(i) + MARGIN.LEFT;  //根据比例尺计算加上一个常量
	  })
	  .attr('y', function (d, i) {       //y坐标
		return SVG_HEIGHT - MARGIN.TOP;
	  })
	  .attr('width', function (d, i) {   //宽度
		return xScale.bandwidth();
	  })
	  .attr('height', function (d) {     //高度
		return 0;   //一开始是0
	  })
	  //动画，过渡
	  .transition()
	  .duration(1000)
	  .delay(function (d, i) {
		return 500 * i;
	  })
	  .attr('y', function (d, i) {
		return yScale(d) + MARGIN.TOP;
	  })
	  .attr('height', function (d) {
		return SVG_HEIGHT - MARGIN.TOP - MARGIN.BOTTOM - yScale(d);
	  })
	  
	  
	//文本
	container.append('g').attr('class', 'textGrop')   //添加一个分组
	container.select('.textGrop')
	  .selectAll('text')   //文本
	  .data(datalist)
	  .enter()
	  .append('text')
	  .attr("text-anchor", "middle")    //居中
	  .text(function (d, i) {
		return d;
	  })
	  .attr('x', function (d, i) {   //文本x轴 在柱的中间
		return xScale(i) + MARGIN.LEFT + xScale.bandwidth() / 2;
	  })
	  .attr('y', function (d, i) {     //文本y轴
		return SVG_HEIGHT - MARGIN.TOP - 10;  //-10让文本在柱体上方10px
	  })
	  //动画过渡
	  .transition()
	  .duration(1000)
	  .delay(function (d, i) {
		return 500 * i;
	  })
	  .attr('x', function (d, i) {
		return xScale(i) + MARGIN.LEFT + xScale.bandwidth() / 2;
	  })
	  .attr('y', function (d, i) {
		return yScale(d) + MARGIN.TOP - 10;
	  })
}
