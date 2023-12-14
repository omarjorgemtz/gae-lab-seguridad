import { Component, OnInit } from '@angular/core';
import { name, version } from '../../package.json';

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {
    version = version;
    name = name;
    styles = [
        'background: linear-gradient(rgba(31, 55, 84, 0.98), #375988)',
        'margin: 10px',
        'padding: 20px',
        'color: white',
        'text-align: center',
        'font-weight: bold'
    ].join(';');

    ngOnInit(): void {
        const tag = `${this.name} (${this.version})`;
        console.log('%c%s', this.styles, tag);
    }
}

