import { Component } from '@angular/core';
import {RouterLink} from "@angular/router";
import {GuestbookRecord} from "../GuestbookRecord";
import {NgForOf, NgIf} from "@angular/common";
import {GuestbookServiceService} from "../guestbook-service.service";
import {FormsModule} from "@angular/forms";

@Component({
  selector: 'app-administrator-page',
  standalone: true,
  imports: [
    RouterLink,
    NgForOf,
    FormsModule,
    NgIf
  ],
  templateUrl: './administrator-page.component.html',
  styleUrl: './administrator-page.component.css'
})
export class AdministratorPageComponent {
  records: GuestbookRecord[] = []
  readonly FIRST_PAGE_NUMBER : number = 1
  readonly VIEW_RECORD_PAGE_URL : string = 'ViewRecordPage.php'
  currentPageNumber : number = this.FIRST_PAGE_NUMBER
  idOfSelectedRecord : number = 0
  selectedRecord : GuestbookRecord
  service : GuestbookServiceService

  currentSortingType : string = ''
  sortByAuthorCheckboxIsChecked : boolean = false
  sortByTitleCheckboxIsChecked : boolean = false

  mainDialogIsOpen : boolean = false
  confirmUpdateDialogIsOpen: boolean = false
  confirmRemoveDialogIsOpen: boolean = false

  constructor(service: GuestbookServiceService) {
    this.service = service
    this.selectedRecord = new GuestbookRecord()
    this.records.push(new GuestbookRecord())
  }

  ngOnInit() {
    this.getRecords()
    console.log(this.records)
  }

  async getRecords() : Promise<void> {
    if (this.currentSortingType === 'byAuthor') {
      this.service.getStudentsOnPageSortedByAuthor(this.currentPageNumber).subscribe(records => this.records = records)
    }
    else if (this.currentSortingType === 'byTitle') {
      this.service.getStudentsOnPageSortedByTitle(this.currentPageNumber).subscribe(records => this.records = records)
    }
    else {
      this.service.getStudentsOnPage(this.currentPageNumber).subscribe(records => this.records = records)
    }
  }

  selectRecord(record: GuestbookRecord) {
    this.selectedRecord = record
    this.mainDialogIsOpen = true
  }

  closeMainDialog() {
    this.mainDialogIsOpen = false
  }

  closeConfirmUpdateDialog() {
    this.confirmUpdateDialogIsOpen = false
  }

  closeConfirmRemoveDialog() {
    this.confirmRemoveDialogIsOpen = false
  }

  openConfirmUpdateDialog() {
    this.confirmUpdateDialogIsOpen = true
  }

  openConfirmRemoveDialog() {
    this.confirmRemoveDialogIsOpen = true
  }

  async confirmRecordRemove() {
    this.service.removeRecord(this.selectedRecord).subscribe(response => console.log(response))
    //this.closeConfirmRemoveDialog()
    //this.getRecords()
  }

  async confirmRecordUpdate() {
    this.service.updateRecord(this.selectedRecord).subscribe(response => console.log(response))
    this.closeConfirmUpdateDialog()
    this.getRecords()
  }

  previousPage() {
    if (this.currentPageNumber > this.FIRST_PAGE_NUMBER) {
      this.currentPageNumber--
    }
    this.getRecords()
  }

  async nextPage() {
    this.currentPageNumber++;
    await this.getRecords(); // doesn't work
    if (this.records.length === 0) {
      this.currentPageNumber--;
      this.getRecords();
    }
  }

  checkSortByAuthor() {
    if (!this.sortByAuthorCheckboxIsChecked) {
      this.currentSortingType = 'byAuthor'
      this.sortByTitleCheckboxIsChecked = false
      this.sortByAuthorCheckboxIsChecked = true
    }
    else
    {
      this.sortByAuthorCheckboxIsChecked = false
      this.currentSortingType = ''
    }
    this.getRecords()
  }

  checkSortByTitle() {
    if (!this.sortByTitleCheckboxIsChecked) {
      this.currentSortingType = 'byTitle'
      this.sortByAuthorCheckboxIsChecked = false
      this.sortByTitleCheckboxIsChecked = true
    }
    else
    {
      this.sortByTitleCheckboxIsChecked = false
      this.currentSortingType = ''
    }
    this.getRecords()
  }
}
