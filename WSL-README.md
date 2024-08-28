# WSL Technical Task

Hi, these are the notes that I (Ben Shutt) have written while completing the Westhill Solutions Technical Task.

## See My Changes

I have committed:

- The starting sample code to `main` (or Apple have)
- My work (extending the sample) to `feature/mrz`

You can do a diff on these branches to preview the changes that I have made.

## First Thoughts

The first thing that comes to mind is that the [WWDC22 video](https://developer.apple.com/videos/play/wwdc2022/10025/) is about [DataScannerViewController](https://developer.apple.com/documentation/visionkit/datascannerviewcontroller) (which removes a lot of the boilerplate) but the sample code is from WWDC19, so a lot older.

I am going to _assume_ that you do *not* want me to use `DataScannerViewController`, perhaps because we might need backwards compatibility beyond iOS 16.

Similarly, having done a QR code scanning delivery app before, where I leveraged [AVCaptureSession](https://developer.apple.com/documentation/avfoundation/avcapturesession) extensively, I was tempted to send you a fresh project without any clutter that just reads and parses MRZ codes (using the camera overlay I built for this project).
The requirements are quite clear on editing the WWDC19 sample code, so I have not done this.

## Feedback

### Prado Reference

On the technical document you are missing the "l" from the following link

```
https://www.consilium.europa.eu/prado/EN/prado-start-page.htm
```

### MRZ Criteria

May just be a miss-reading thing on my part but where it says "3 remaining lines" implies that there are 4 lines.
