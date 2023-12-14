import { Component, OnInit } from '@angular/core';
import { environment } from 'src/environments/environment';

@Component({
    selector: 'app-window-open',
    templateUrl: './window-open.component.html',
    styleUrls: ['./window-open.component.scss']
})
export class WindowOpenComponent implements OnInit {
    constructor() {}

    ngOnInit(): void {
        this.setCookie('myFirstCookie', 'CookiePeligrosa', 1);
    }

    abrirURL(id) {
        let dangerousVideoUrl = 'https://www.youtube.com/embed/' + id;
        window.open(dangerousVideoUrl);
    }

    setCookie(nombre, valor, expiracionDias) {
        localStorage.setItem('apikey', environment.apikey);
        localStorage.setItem('jwt', environment.jwt);
        const fechaExpiracion = new Date();
        fechaExpiracion.setTime(
            fechaExpiracion.getTime() + expiracionDias * 24 * 60 * 60 * 1000
        );
        const expira = 'expires=' + fechaExpiracion.toUTCString();
        document.cookie = nombre + '=' + valor + ';' + expira + ';path=/';
    }

    deleteCookie(nombre) {
        document.cookie =
            nombre + '=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
    }
}

