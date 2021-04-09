var (width, height) = (1024, 1024);
# Create a standalone Canvas (not attached to any GUI dialog/aircraft etc) 
var myCanvas = canvas.new({
  "name": "EFBtablet",   # The name is optional but allow for easier identification
  "size": [width, height], # Size of the underlying texture (should be a power of 2, required) [Resolution]
  "view": [893, 1024],  # Virtual resolution (Defines the coordinate system of the canvas [Dimensions]
                        # which will be stretched the size of the texture, required)
  "mipmapping": 1       # Enable mipmapping (optional)
});
myCanvas.addPlacement({"node": "EFBscreen"});
# set background color
myCanvas.set("background", canvas.style.getColor("bg_color"));

# creating the top-level/root group which will contain all other elements/group
var root = myCanvas.createGroup();
var myText = root.createChild("text")
      .setText("Welcome, this is new EFB system test")
      .setFontSize(20, 0.9)          # font size (in texels) and font aspect ratio
      .setColor(1,0,0,1)             # red, fully opaque
      .setAlignment("center-center") # how the text is aligned to where you place it
      .setFont("LiberationFonts/LiberationSans-Regular.ttf")
      .setTranslation(210, 80);     # where to place the text
# create a new layout
var myLayout = canvas.HBoxLayout.new();
# assign it to the Canvas
myCanvas.setLayout(myLayout);

# click button

var button = canvas.gui.widgets.Button.new(root, canvas.style, {})
	.setText("SP-NTX")
	.setFixedSize(75, 25);

button.listen("clicked", func {
        # add code here to react on click on button.
print("Button clicked !");
});

myLayout.addItem(button);

# OPTIONAL: Create a Canvas dialog window to hold the canvas and show that it's working
# the Canvas is now standalone, i.e. continues to live once the dialog is closed!
#var window = canvas.Window.new([width,height],"dialog");
#window.setCanvas(myCanvas);