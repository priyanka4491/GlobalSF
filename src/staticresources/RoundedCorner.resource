Chart.elements.RectangleRounded = Chart.elements.Rectangle.extend({
draw: function() {
var ctx = this._chart.ctx;
var vm = this._view;
var helpers = Chart.helpers;
var halfWidth = vm.width / 2,
leftX = vm.x - halfWidth,
rightX = vm.x + halfWidth,
top = vm.base - (vm.base - vm.y),
halfStroke = vm.borderWidth / 2;
// Canvas doesn't allow us to stroke inside the width so we can
// adjust the sizes to fit if we're setting a stroke on the line
if (vm.borderWidth) {
leftX += halfStroke;
rightX -= halfStroke;
top += halfStroke;
}
ctx.beginPath();
ctx.fillStyle = vm.backgroundColor;
ctx.strokeStyle = ctx.fillStyle;//vm.borderColor;
ctx.lineWidth = vm.borderWidth;

    // Corner points, from bottom-left to bottom-right clockwise
    // | 1 2 |
    // | 0 3 |
    var corners = [
        [leftX, vm.base],
        [leftX, top],
        [rightX, top],
        [rightX, vm.base]
    ];
    // Find first (starting) corner with fallback to 'bottom'
    var borders = ['bottom', 'left', 'top', 'right'];
    var startCorner = borders.indexOf(vm.borderSkipped, 0);
    if (startCorner === -1) {
        startCorner = 0;
    }
    function cornerAt(index) {
        return corners[(startCorner + index) % 4];
    }
    // Draw rectangle from 'startCorner'
    ctx.moveTo.apply(ctx, cornerAt(0));
    for (var i = 1; i < 4; i++) {
        ctx.lineTo.apply(ctx, cornerAt(i));
    }
    // Set faux rounded corners
    ctx.lineJoin = "round";
    ctx.lineWidth = 10;
    vm.borderWidth = vm.borderWidth || 5;

	//Rounded Rectangle
			if (vm.opacity === 0) {
				return;
			}

			var tooltipSize = this.getTooltipSize(vm);
			var pt = {
				x: vm.x,
				y: vm.y
			};
	//helpers.drawRoundedRectangle(ctx, pt.x, pt.y, tooltipSize.width, tooltipSize.height, vm.cornerRadius);
	
	
    ctx.fill();
    if (vm.borderWidth) {
        ctx.stroke();
    }
},

getTooltipSize: function(vm) {
	var helpers = Chart.helpers;
			var ctx = this._chart.ctx;

			var size = {
				height: vm.yPadding * 2, // Tooltip Padding
				width: 0
			};

			// Count of all lines in the body
			var body = vm.body;
			
			//combinedBodyLength += vm.beforeBody.length + vm.afterBody.length;

			//var titleLineCount = vm.title.length;
			//var footerLineCount = vm.footer.length;
			var titleFontSize = vm.titleFontSize,
				bodyFontSize = vm.bodyFontSize,
				footerFontSize = vm.footerFontSize;
			

			// Title width
			var widthPadding = 0;
			var maxLineWidth = function(line) {
				size.width = Math.max(size.width, ctx.measureText(line).width + widthPadding);
			};

			ctx.font = helpers.fontString(titleFontSize, vm._titleFontStyle, vm._titleFontFamily);
			helpers.each(vm.title, maxLineWidth);

			// Body width
			ctx.font = helpers.fontString(bodyFontSize, vm._bodyFontStyle, vm._bodyFontFamily);
			//helpers.each(vm.beforeBody.concat(vm.afterBody), maxLineWidth);

			// Body lines may include some extra width due to the color box
			//widthPadding = body.length > 1 ? (bodyFontSize + 2) : 0;
			helpers.each(body, function(bodyItem) {
				helpers.each(bodyItem.before, maxLineWidth);
				helpers.each(bodyItem.lines, maxLineWidth);
				helpers.each(bodyItem.after, maxLineWidth);
			});

			// Reset back to 0
			widthPadding = 0;

			// Footer width
			ctx.font = helpers.fontString(footerFontSize, vm._footerFontStyle, vm._footerFontFamily);
			helpers.each(vm.footer, maxLineWidth);

			// Add padding
			size.width += 2 * vm.xPadding;

			return size;
		}

});

Chart.controllers.bar = Chart.controllers.bar.extend({
dataElementType: Chart.elements.RectangleRounded,
});