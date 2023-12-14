import { ComponentFixture, TestBed } from '@angular/core/testing';

import { WindowOpenComponent } from './window-open.component';

describe('WindowOpenComponent', () => {
    let component: WindowOpenComponent;
    let fixture: ComponentFixture<WindowOpenComponent>;

    beforeEach(async () => {
        await TestBed.configureTestingModule({
            declarations: [WindowOpenComponent]
        }).compileComponents();
    });

    beforeEach(() => {
        fixture = TestBed.createComponent(WindowOpenComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
    });

    it('should create', () => {
        expect(component).toBeTruthy();
    });
});

