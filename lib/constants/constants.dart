export 'enums.dart';
export 'regex.dart';

// const baseUrl = 'https://max-trivia.uc.r.appspot.com/'; // Real app
const baseUrl = 'http://127.0.0.1:8000/'; // Web testing
// const baseUrl = 'ws://10.0.2.2:8000/'; // Android testing
//
// const baseUrl = _base;
// // const wsUrl = 'ws$_base';

const sendHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Content-Type': 'application/json; charset=UTF-8',
};
