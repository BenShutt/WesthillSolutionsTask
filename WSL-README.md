# WSL Technical Task

This is the supporting documentation that I (Ben Shutt) have written alongside my solution to the Westhill Solutions Technical Task.

## My Changes

I have committed:

- The starting sample code on the `main` branch (Apple already had)
- My MRZ changes (extending the sample) on the `feature/mrz` branch

You can do a diff on these branches to preview the changes that I have made.

## Initial Thoughts

The first thing that comes to mind is that the [WWDC22 video](https://developer.apple.com/videos/play/wwdc2022/10025/) is about [DataScannerViewController](https://developer.apple.com/documentation/visionkit/datascannerviewcontroller) (which removes a lot of the boilerplate) but the sample code is from WWDC19, so fair bit older.

I am going to _assume_ that you do **not** want me to use `DataScannerViewController`, perhaps because we might need backwards compatibility beyond iOS 16.

Similarly, having built a QR code scanning delivery app before, where I leveraged [AVCaptureSession](https://developer.apple.com/documentation/avfoundation/avcapturesession) extensively, I was tempted to send you a fresh project without any clutter that just reads and parses MRZ codes.
This would have been a bit faster and the UI a lot nicer.
But the requirements are quite clear about editing the WWDC19 sample code, so I have not done this.

## Challenges

- Undoubtedly, the primary challenge is that the (camera read) text results are returned as single lines whereas a valid MRZ has multiple. My solution was to group the lines based on character count and send them through the parser (in an efficient-ish way such as assuming correct order). I _strongly_ suspect there is a better way and would, given more time, investigate that
- The [recognitionLevel](https://developer.apple.com/documentation/vision/vnrecognizetextrequest/recognitionlevel) needed to be `.accurate`, perhaps there is a way to make it work faster

### Less Important

- Understanding `bufferAspectRatio` and how we need to cater for it
- Transformations based on device orientation. This sample project (because of its use case) is a little over-engineered for our MRZ use case. I think when using the camera to scan a passport, it is not unreasonable to ask the user to simply rotate their device so it is landscape which results in a better mask
- Ugly UI that ought to be better, given more time I would definitely sort this

## Time Limit

This task was time-boxed to 4 hours maximum. In this time I:

- Watched the WWDC video
- Read through various documentation (VisionKit, AVKit, MRZ standards)
- Tried the Innovatrics DOT app
- Familiarized myself with this Apple sample project
- Implemented the technical tasks (see branch diff) on top of the sample project
  - As you know, editing code can take longer than writing it new
- Tested my changes
- Wrote this `README` and other codebase documentation

I am finishing now by answering your final questions on the task criteria.
Due to the time limit, I can not complete any more features in the time.
If other candidates have done more in the 4h I would be interested to know if they actually stuck to the 4h.

## Answers To Your Questions

> How could you give feedback to the user on whether the document is too far away or too close? (Hint, we didn't use text rectangles for this, but you could.)

A little toast saying something like "please move closer" is quite clear, but it doesn't need to stop there. 
I personally quite like modifying the frame (aka the mask) to indicate how good of a job the user is doing at scanning their document.
For example, green for excellent position, amber means the app is trying but struggling, red for bad framing.

> How could you give feedback to the user on whether the image has too much reflection, is too bright or too dark?

In a perfect world the app would be able to adjust accordingly, but that has a lot of hardware dependency.
In the delivery QR code app that I mentioned I added a button to enable the device torch for the user to use while scanning.
Lastly, I would fallback on helpful and clear wording.

> How could you test the above scenarios (document too far, too close, too bright) to check for changes within the app?

You can do a lot with simulators. For example, low-light simulation for accessibility testing (perhaps with [Browserstack](https://www.google.com/search?client=safari&rls=en&q=Browserstack&ie=UTF-8&oe=UTF-8) or equivalent).
Importantly, there has to be some in-person testing running through the different cases. 
Ideally, in an objective way so we can report on what is supported.

> How could you test the above scenarios (document too far, too close, too bright) to compare our implementation, and detection speed, to the Innovatrics DOT app?

The in-person tests can obviously be done side-by-side.
I am not completely sure on whether we could get an `.ipa` of the Innovatrics DOT app for automated testing.

> How can we test the apps response bad / partial / malformed MRZ text lines?

Unit and UI tests!
Unit tests may be leveraged extensively for, say, parsing an MRZ with various challenging cases.
UI tests (or equivalent testing frameworks) can be used to see how the app behaves in pre-defined environments.

> What optimizations could be made to improve the text detection speed?

As mentioned above, there is a setting to use a [.fast](https://developer.apple.com/documentation/vision/vnrequesttextrecognitionlevel/fast) recognition level for quicker processing.

Importantly, when developing parsing algorithms we need to be mindful of _complexity_ (the notorious order notation).
Unit tests can be used to measure timing but, in addition to that, there needs to be an understanding of how demanding the algorithm is.

Often it is preferable to opt for readability over performance when the performance difference is negligible. 
For a parsing algorithm like this that is regularly called, we might err on the side of efficiency.
Even if that means a small sacrifice to simplicity and readability.

> What are the overall steps of the process - (this more identifies what parts of the business logic might be identical, or with KMP shared) between Android / iOS?

The parsing algorithm will be the same.
The UI and UX would be very similar too such as the logic that determines when feedback shows.
The only difference really is integrating with the hardware (and thus the SDK APIs) and platform design standards.

> MRZ is a standard, but has variations - eg. Russian Identity cards, and character transliteration. How might we handle a situation where a customer comes to us and says "passports aren't scanning and our passengers are getting frustrated"?

Exceptions to the rule ought to be added as another case in the unit tests; any changes made should successfully handle the new case while also pass existing tests.
Regarding how the app might deal with the situation there and then, there would have to be a fallback to text input.

> When deciding whether to buy an off the shelf solution like Innovatrics DOT, or create our own, what would you consider after understanding more about the effort and maintenance costs?

Quite a few things to consider here (not limited to):

- The time it would take us to make the equivalent equates to a cost which can be compared to the cost of the product
- Something highly technical ought to be written by an expect. For example, one should hesitate before writing their own hashing algorithm. Industry standard third-party software should be used
- We should consider how easily it can be replaced and the dependency that we have on it. This is an argument for doing it ourselves sometimes

## Bonus Questions

> The second stage of passport / identity verification is using the MRZ data to unlock the NFC chip. This validates that a person is in physical possession of that passport.
If we can match their name on a booking, to the name read from the passport, how sure can we be (what commitment can we make as vendor, to our customers) that the identity document isn't fraudulent? So - this is a typical "put yourself in the mindset of a criminal" - what ways can you think of that you could/would you defraud this process knowing the steps involved?

If the user has access to their passport, using reliable facial recognition could be a good way to improve confidence that the user is not fraudulent.

Regarding NFC, I am hesitant to say "confident". 
We should be mindful that a criminal:
- Is able to scan passports in close proximity so is no guarantee
- May have stolen or found a passport

To be honest though, I would want more time to think about the answer to this question and I am limited to 4 hours.

> If we are asked to store the data, or a subset of the data read from the passport, so it can be re-used without going through the process again, what precautions could or should be taken?

Firstly, I would push back a little and ask "do we _really_ need to store it?".
If yes, then the [Keychain](https://developer.apple.com/documentation/security/keychain-services) is a secure place to store sensitive data like passwords.
It is worth noting that Jailbroken devices can access it and, on the client-side, the app can be decompiled revealing source-code.

Perhaps this app has accounts, if so:

- Authenticate their app session with biometrics
- On successful login, generating a short-lived, revokable access token
- Fetching this data from a server with this token
- Potentially adding additional layers of encryption to protect against man-in-the-middle

## Task Criteria Amends?

### Prado Reference

On the technical document you are missing the "l" from the following link

```
https://www.consilium.europa.eu/prado/EN/prado-start-page.htm
```

### MRZ Criteria

I may just be a miss-reading this but where it says "3 remaining lines" implies that there are 4 lines.