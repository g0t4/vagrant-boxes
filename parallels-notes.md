# parallels notes

## links

- downloads:
  - Parallels Desktop for Mac Installation Images:
    - https://my.parallels.com/desktop/pdfm/downloads
  - Toolbox:
    - https://my.parallels.com/toolbox/downloads
- SDK:
  - download:
    - https://survey.parallels.com/s3/Parallels-SDK-download
      - had to sign in to find this link that is public... ugh
  - sdk path:
    - /Library/Frameworks/ParallelsVirtualizationSDK.framework/Versions
  - pdf docs:
    - Programmer's Guide:
      - https://download.parallels.com/desktop/v19/docs/en_US/Parallels%20Virtualization%20SDK%20Programmer's%20Guide/
    - SDK ref:
      - https://download.parallels.com/desktop/v19/docs/en_US/Parallels%20C%20API%20Reference/frames.html?frmname=topic&frmfile=index.html
    - more at:
      - https://my.parallels.com/desktop/pdfm/downloads
- cli docs `prlctl` and `prlsrvctl`:
  - https://download.parallels.com/desktop/v19/docs/en_US/Parallels%20Desktop%20Command-Line%20Reference/

## FYI as of v19 parallels said you don't need the SDK

Starting Parallels Desktop 19, using Parallels Virtualization SDK is no longer required to use Packer with Parallels VMs.

Parallels Desktop 19 adds the ability to send keyboard key events (press/release) using the prlctl command-line tool, e.g.

$ prlctl send-key-event %VM ID% -k,--key %key% | -s,--scancode %scancode% [-e,--event %press|release%] [-d,--delay %msec%]

You are welcome to share feedback and ask questions about these improvements, as well as discuss feature suggestions and have fun with like-minded people at Parallels Desktop Discord channel.

In case you still need to download the SDK, please click "Submit" and the download will begin automatically.
