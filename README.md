# Duck Hunter

You are in a forest with a buckshot gun. Flying ducks. Enjoy!

[![GAME VIDEO DEMO](http://img.youtube.com/vi/vCKdGLf996Q/0.jpg)](http://www.youtube.com/watch?v=vCKdGLf996Q)

## Get Started

### Install on Playdate

On your PC/Mac or Mobile:
- Download the game zip file **duckhunter.pdx.zip** from the [latest release](https://github.com/Tpelleterat/playdate-duck-hunter/releases).
- Visit your [Playdate account in sideload](https://play.date/account/sideload/).
- Upload the zip file.

On Playdate:
- Navigate to Settings > Games.
- Run **Refresh List**.
- Scroll to **My Games**.
- Open **Duck Hunter**.
- Click on **Install Game**.
- Return to the home screen.
- Enjoy the game!

### Install on Simulator

On your PC/Mac:
- Install the simulator from this [link](https://play.date/dev/).
- Download the game zip file **duckhunter.pdx.zip** from the [latest release](https://github.com/Tpelleterat/playdate-duck-hunter/releases).
- Unzip the file.
- In the simulator, click on File > Open and select the unzipped folder (or drag and drop the folder onto the simulator).

## How to Develop

### Check Installation

Open the terminal and execute the command:

```batch
pdc --version
```
If the command is not recognized, check the environment variables:

- On Windows, add the bin path of the SDK to the PATH and add the variable PLAYDATE_SDK_PATH. More information can be found [here](https://sdk.play.date/2.2.0/Inside%20Playdate.html#_compiling_a_project).

### Install Extension
In Visual Studio Code (vscode), go to extensions and install the recommended extensions.

The project is automatically built by a command executed on the save event by the Run on Save extension.
Open the file .vscode/settings.json to check this command.

Test the command:
Open the **OUTPUT** view and select the **Run On Save** output. Make a modification to any file to check if the extension executes the command successfully.

### Run on Simulator

Once the project is built, a folder is created in **/bin**. To run the game on the simulator, follow these steps:

1. Navigate to the simulator and choose **File > Open...**.
2. Select the **duckhunter.pdx** folder inside the **/bin** directory.

### Pack the Game

To pack the game for distribution, follow these steps:

1. Locate the **/bin** folder where the project was built.
2. Zip the entire **duckhunter.pdx** folder.
3. Change the file extension from **.zip** to **.pdx** to ensure compatibility with the Playdate platform.

## Resources

- [1 bit image converter](https://29a.ch/ditherlicious/)
- [Sample sprite drawing](https://github.com/SquidGodDev/PlaydateSDKSpriteDrawing/blob/main/source/circle.lua)
- [Sample animation](https://github.com/mierau/playdate-animatedimage)
- [Cut sprite](https://ezgif.com/sprite-cutter)
- [Font creator](https://play.date/caps/)
- [If unsupported WAV encoding type](https://www.3cx.com/docs/converting-wav-file/)
- [Hunt sound effect](https://freesound.org/search/?q=hunt)
