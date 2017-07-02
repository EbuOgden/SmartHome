/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

#if !os(Linux)
import XCTest
import TextToSpeechV1
import AVFoundation

class TextToSpeechPlaybackTests: XCTestCase {
    
    private var textToSpeech: TextToSpeech!
    private let timeout: TimeInterval = 5.0
    private let playAudio = true
    private let text = "Swift at IBM is awesome. You should try it!"
    private let germanText = "Erst denken, dann handeln."
    private let japaneseText = "こんにちは"
    private let ssmlString = "<speak xml:lang=\"En-US\" version=\"1.0\">" +
    "<say-as interpret-as=\"letters\">Hello</say-as></speak>"
    
    
    // MARK: - Test Configuration
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        instantiateTextToSpeech()
    }
    
    /** Instantiate Text to Speech instance. */
    func instantiateTextToSpeech() {
        let username = Credentials.TextToSpeechUsername
        let password = Credentials.TextToSpeechPassword
        textToSpeech = TextToSpeech(username: username, password: password)
    }
    
    /** Fail false negatives. */
    func failWithError(error: Error) {
        XCTFail("Positive test failed with error: \(error)")
    }
    
    /** Wait for expectations. */
    func waitForExpectations() {
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, "Timeout")
        }
    }
    
    // MARK: - Positive Tests
    
    /** Synthesize text to spoken audio using the default parameters. */
    func testSynthesizeDefault() {
        let description = "Synthesize text to spoken audio using the default parameters."
        let expectation = self.expectation(description: description)
        
        textToSpeech.synthesize(text, failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(3)
                }
            } catch {
                XCTFail("Failed to initialize an AVAudioPlayer with the received data.")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Synthesize text to spoken audio using the Lisa voice. */
    func testSynthesizeLisa() {
        let description = "Synthesize text to spoken audio."
        let expectation = self.expectation(description: description)
        
        textToSpeech.synthesize(text, voice: SynthesisVoice.us_Lisa.rawValue, audioFormat: .wav, failure: failWithError) {
            data in
            XCTAssertGreaterThan(data.count, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(3)
                }
            } catch {
                XCTFail("Failed to initialize an AVAudioPlayer with the received data.")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Synthesize text to spoken audio using the Dieter voice. */
    func testSynthesizeDieter() {
        let description = "Synthesize text to spoken audio."
        let expectation = self.expectation(description: description)
        
        textToSpeech.synthesize(germanText, voice: SynthesisVoice.de_Dieter.rawValue, audioFormat: .wav, failure: failWithError) {
            data in
            XCTAssertGreaterThan(data.count, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(2)
                }
            } catch {
                XCTFail("Failed to initialize an AVAudioPlayer with the received data.")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Synthesize text to spoken audio using the Emi voice. */
    func testSynthesizeEmi() {
        let description = "Synthesize text to spoken audio."
        let expectation = self.expectation(description: description)
        
        textToSpeech.synthesize(japaneseText, voice: SynthesisVoice.jp_Emi.rawValue, audioFormat: .wav, failure: failWithError) {
            data in
            XCTAssertGreaterThan(data.count, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(2)
                }
            } catch {
                XCTFail("Failed to initialize an AVAudioPlayer with the received data.")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
    
    /** Synthesize SSML to spoken audio. */
    func testSynthesizeSSML() {
        let description = "Synthesize SSML to spoken audio."
        let expectation = self.expectation(description: description)
        
        textToSpeech.synthesize(ssmlString, failure: failWithError) { data in
            XCTAssertGreaterThan(data.count, 0)
            do {
                let audioPlayer = try AVAudioPlayer(data: data)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                if self.playAudio {
                    sleep(1)
                }
            } catch {
                XCTFail("Failed to initialize an AVAudioPlayer with the received data.")
            }
            expectation.fulfill()
        }
        waitForExpectations()
    }
}
#endif
