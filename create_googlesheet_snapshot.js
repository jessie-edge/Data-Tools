function captureTrends() {
  var ss = SpreadsheetApp.openById(" SHEET ID ");
  var dashboardSheet = ss.getSheetByName("SHEET A");
  var snapshotSheet = ss.getSheetByName("SHEET B");

  if (!dashboardSheet || !snapshotSheet) {
    Logger.log("One or both of the specified sheets do not exist.");
    return;
  }

  var timestamp = new Date();
  var data = dashboardSheet.getDataRange().getValues();

  if (data.length === 0) {
    Logger.log("Dashboard sheet is empty.");
    return;
  }

  var dataWithTimestamp = data.map(function(row, index) {
    if (index === 0 && snapshotSheet.getLastRow() === 0) {
      return ["Snapshot Timestamp"].concat(row);
    } else if (index > 0) {
      return [timestamp].concat(row);
    }
  }).filter(Boolean); // remove undefined rows

  if (dataWithTimestamp.length === 0) {
    Logger.log("No data to write after processing.");
    return;
  }

  var startRow = snapshotSheet.getLastRow() + 1;
  var numRows = dataWithTimestamp.length;
  var numCols = dataWithTimestamp[0].length;

  Logger.log("Start row: " + startRow);
  Logger.log("Num rows: " + numRows);
  Logger.log("Num cols: " + numCols);
  Logger.log("First row of data: " + JSON.stringify(dataWithTimestamp[0]));

  snapshotSheet.getRange(startRow, 1, numRows, numCols).setValues(dataWithTimestamp);

  Logger.log("Snapshot captured at: " + timestamp);
}
