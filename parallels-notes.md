# parallels notes


## downloads

- https://my.parallels.com/desktop/pdfm/downloads
- SDK: https://survey.parallels.com/s3/Parallels-SDK-download
    - had to sign in to find this link that is public... ugh

## FYI as of v19 parallels said you don't need the SDK

Starting Parallels Desktop 19, using Parallels Virtualization SDK is no longer required to use Packer with Parallels VMs. 

Parallels Desktop 19 adds the ability to send keyboard key events (press/release) using the prlctl command-line tool, e.g.

$ prlctl send-key-event %VM ID% -k,--key %key% | -s,--scancode %scancode% [-e,--event %press|release%] [-d,--delay %msec%]

You are welcome to share feedback and ask questions about these improvements, as well as discuss feature suggestions and have fun with like-minded people at Parallels Desktop Discord channel.

In case you still need to download the SDK, please click "Submit" and the download will begin automatically.

