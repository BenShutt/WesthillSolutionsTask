# WSL Technical Task

These are the notes that I (Ben Shutt) have written while completing the Westhill Solutions Technical Task.

## See My Changes

I have committed:

- The starting sample code on `main` (or Apple have)
- My MRZ changes (extending the sample) on `feature/mrz`

You can do a diff on these branches to preview the changes that I have made.

## First Thoughts

The first thing that comes to mind is that the [WWDC22 video](https://developer.apple.com/videos/play/wwdc2022/10025/) is about [DataScannerViewController](https://developer.apple.com/documentation/visionkit/datascannerviewcontroller) (which removes a lot of the boilerplate) but the sample code is from WWDC19, so fair bit older.

I am going to _assume_ that you do *not* want me to use `DataScannerViewController`, perhaps because we might need backwards compatibility beyond iOS 16.

Similarly, having done a QR code scanning delivery app before, where I leveraged [AVCaptureSession](https://developer.apple.com/documentation/avfoundation/avcapturesession) extensively, I was tempted to send you a fresh project without any clutter that just reads and parses MRZ codes (using the camera overlay and feedback UI I built for this project).
The requirements are quite clear about editing the WWDC19 sample code, so I have not done this.

## Challenges

- Understanding `bufferAspectRatio` and how we need to cater for it
- Transformations based on device orientation. This project (because of its use case) is a little over-engineered for our MRZ use case. I think when using the camera to scan a passport, it is not unreasonable to inform the user to simply rotate their device so it is landscape which results in a better mask
- (Jokingly) using tabs instead of spaces in Xcode! I thought Apple used spaces?

## Feedback

### Prado Reference

On the technical document you are missing the "l" from the following link

```
https://www.consilium.europa.eu/prado/EN/prado-start-page.htm
```

### MRZ Criteria

May just be a miss-reading thing on my part but where it says "3 remaining lines" implies that there are 4 lines.
