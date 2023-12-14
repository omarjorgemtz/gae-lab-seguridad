import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { MatButtonModule } from '@angular/material/button';
import { MatChipsModule } from '@angular/material/chips';
import { MatDividerModule } from '@angular/material/divider';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BypassSecurityComponent } from './bypass-security/bypass-security.component';
import { InnerHtmlBindingComponent } from './inner-html-binding/inner-html-binding.component';
import { WindowOpenComponent } from './window-open/window-open.component';
import { AddIconExampleComponent } from './add-icon-example/add-icon-example.component';

@NgModule({
    declarations: [
        AppComponent,
        BypassSecurityComponent,
        InnerHtmlBindingComponent,
        WindowOpenComponent,
        AddIconExampleComponent
    ],
    imports: [
        BrowserModule,
        AppRoutingModule,
        BrowserAnimationsModule,
        MatChipsModule, // Ex. Material component (remove if necessary)
        MatButtonModule,
        MatDividerModule
    ],
    providers: [],
    bootstrap: [AppComponent]
})
export class AppModule {}

