import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AdministratorPageComponent } from './administrator-page.component';

describe('AdministratorPageComponent', () => {
  let component: AdministratorPageComponent;
  let fixture: ComponentFixture<AdministratorPageComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AdministratorPageComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(AdministratorPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
