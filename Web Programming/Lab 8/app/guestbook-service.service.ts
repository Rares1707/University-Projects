import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from "@angular/common/http";
import {catchError, Observable, of} from 'rxjs';
import { GuestbookRecord } from './GuestbookRecord';
import axios from 'axios';

@Injectable({
  providedIn: 'root'
})
export class GuestbookServiceService {
  private readonly backendBaseUrl: string = "http://localhost/WebProgrammingLab7/Backend/"
  private readonly addRecordUrl: string = this.backendBaseUrl + "add_record.php"
  private readonly getRecordsUrl: string = this.backendBaseUrl + "fetch_entries.php"
  private readonly updateRecordUrl: string = this.backendBaseUrl + "update_record.php"
  private readonly removeRecordUrl: string = this.backendBaseUrl + "delete_entry.php"

  // not needed
  private httpOptions = {
    headers: new HttpHeaders({
      'Content-Type':  'application/json'
    })
  };
  constructor(private http : HttpClient) {
  }

  getStudentsOnPage(pageNumber: number): Observable<GuestbookRecord[]> {
    return this.http.get<GuestbookRecord[]>(this.getRecordsUrl + '?page=' + pageNumber)
      .pipe(catchError(this.handleError<GuestbookRecord[]>('getStudentsOnPage', [])))
  }

  getStudentsOnPageSortedByAuthor(pageNumber: number): Observable<GuestbookRecord[]> {
    return this.http.get<GuestbookRecord[]>(this.getRecordsUrl + '?page=' + pageNumber + '&sortingType=byAuthor')
      .pipe(catchError(this.handleError<GuestbookRecord[]>('getStudentsOnPageSortedByAuthor', [])))
  }

  getStudentsOnPageSortedByTitle(pageNumber: number): Observable<GuestbookRecord[]> {
    return this.http.get<GuestbookRecord[]>(this.getRecordsUrl + '?page=' + pageNumber + '&sortingType=byTitle')
      .pipe(catchError(this.handleError<GuestbookRecord[]>('getStudentsOnPageSortedByTitle', [])))
  }

  removeRecord(record: GuestbookRecord): Observable<string> {
    return this.http.post<string>(this.removeRecordUrl,
      {
        entry_id: record.id,
      })
      .pipe(catchError(this.handleError<string>('removeRecord', '')))
  }

  // Post requests don't work but we can do everything with Get requests.
  // Be careful of what is in the backend
  updateRecord(record: GuestbookRecord): Observable<any> {
    /*return this.http.post<any>(this.updateRecordUrl,
      {
        id: record.id,
        author: record.author_email,
        title: record.title,
        comment: record.comment,
        datetime: record.date
      })
      .pipe(catchError(this.handleError<string>('updateRecord', ''))
    )*/
    return this.http.get<any>(this.updateRecordUrl + '?id=' + record.id +
      '&author=' + record.author_email + '&title=' + record.title + '&comment=' +
      record.comment + '&datetime=' + record.date)
      .pipe(catchError(this.handleError<string>('updateRecord', ''))
      )
  }

  addRecord(author: string, title : string, comment : string): Observable<string> {
    return this.http.post<string>(this.addRecordUrl,
      {author: author,
        title: title,
        comment: comment})
      .pipe(catchError(this.handleError<string>('addRecord', ''))
    )
  }

  /**
   * Handle Http operation that failed.
   * Let the app continue.
   * (taken straight from professor Forest's example)
   * @param operation - name of the operation that failed
   * @param result - optional value to return as the observable result
   * @private
   */
  private handleError<T>(operation = 'operation', result?: T) {
    return (error: any): Observable<T> => {
      console.error(error)
      return of(result as T)
    }
  }
}
