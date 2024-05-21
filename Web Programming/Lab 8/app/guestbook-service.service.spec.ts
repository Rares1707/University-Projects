import { TestBed } from '@angular/core/testing';

import { GuestbookServiceService } from './guestbook-service.service';

describe('GuestbookServiceService', () => {
  let service: GuestbookServiceService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(GuestbookServiceService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
