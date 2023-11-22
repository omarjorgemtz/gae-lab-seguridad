import { Component } from '@angular/core';
import {
    DomSanitizer,
    SafeResourceUrl,
    SafeUrl
} from '@angular/platform-browser';

@Component({
    selector: 'app-bypass-security',
    templateUrl: './bypass-security.component.html',
    styleUrls: ['./bypass-security.component.scss']
})
export class BypassSecurityComponent {
    dangerousUrl: string;
    trustedUrl: SafeUrl;
    dangerousVideoUrl!: string;
    videoUrl!: SafeResourceUrl;

    constructor(private sanitizer: DomSanitizer) {
        // javascript: URLs are dangerous if attacker controlled.
        // Angular sanitizes them in data binding, but you can
        // explicitly tell Angular to trust this value:
        this.dangerousUrl =
            'javascript:alert("Hola, aquí puede haber un script malicioso")';
        //const cleanUrl = safeHtml(this.dangerousUrl);
        console.log('Dirty: ', this.dangerousUrl);
        //console.log("Clean: ", cleanUrl);
        this.trustedUrl = sanitizer.bypassSecurityTrustUrl(this.dangerousUrl);
        this.updateVideoUrl('PUBnlbjZFAI');
    }

    updateVideoUrl(id: string) {
        // Appending an ID to a YouTube URL is safe.
        // Always make sure to construct SafeValue objects as
        // close as possible to the input data so
        // that it's easier to check if the value is safe.
        this.dangerousVideoUrl = 'https://www.youtube.com/embed/' + id;
        this.videoUrl = this.sanitizer.bypassSecurityTrustResourceUrl(
            this.dangerousVideoUrl
        );
    }
}
