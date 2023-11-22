import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddIconExampleComponent } from './add-icon-example.component';

describe('AddIconExampleComponent', () => {
  let component: AddIconExampleComponent;
  let fixture: ComponentFixture<AddIconExampleComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddIconExampleComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddIconExampleComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
