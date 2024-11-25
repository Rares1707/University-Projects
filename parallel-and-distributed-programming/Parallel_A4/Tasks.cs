using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace Parallel_A4
{
    public class Tasks
    {
        public static async Task MainTasks(string[] args)
        {
            var entry = Dns.GetHostEntry(State.Host);
            var socket = new Socket(SocketType.Stream, ProtocolType.Tcp);
            var endpoint = new IPEndPoint(entry.AddressList[0], State.Port);
            var state = new State(socket);

            await ConnectAsync(state, endpoint);
            await SendAsync(state, $"GET /documente-utile/ HTTP/1.1\r\nHost: {State.Host}\r\n\r\n");
            await ReceiveAsync(state);

            Console.WriteLine(state.Content.ToString());
            state.Socket.Close();
        }

        private static Task ConnectAsync(State state, EndPoint endpoint)
        {
            var tcs = new TaskCompletionSource<bool>();
            state.Socket.BeginConnect(endpoint, ar =>
            {
                try
                {
                    state.Socket.EndConnect(ar);
                    tcs.SetResult(true);
                }
                catch (Exception ex)
                {
                    tcs.SetException(ex);
                }
            }, state);
            return tcs.Task;
        }
        
        private static Task SendAsync(State state, string request)
        {
            var tcs = new TaskCompletionSource<bool>();
            var requestBytes = Encoding.UTF8.GetBytes(request);
            state.Socket.BeginSend(requestBytes, 0, requestBytes.Length, SocketFlags.None, ar =>
            {
                try
                {
                    var bytesSent = state.Socket.EndSend(ar);
                    tcs.SetResult(true);
                }
                catch (Exception ex)
                {
                    tcs.SetException(ex);
                }
            }, state);
            return tcs.Task;
        }

        private static Task ReceiveAsync(State state)
        {
            var tcs = new TaskCompletionSource<bool>();
            Action<IAsyncResult> receiveCallback = null;
            receiveCallback = ar =>
            {
                try
                {
                    var bytesReceived = state.Socket.EndReceive(ar);
                    if (bytesReceived == 0)
                    {
                        tcs.SetResult(true);
                    }
                    else
                    {
                        var responseText = Encoding.UTF8.GetString(state.Buffer, 0, bytesReceived);
                        state.Content.Append(responseText);
                        state.Socket.BeginReceive(state.Buffer, 0, State.BufferLength, SocketFlags.None, new AsyncCallback(receiveCallback), state);
                    }
                }
                catch (Exception ex)
                {
                    tcs.SetException(ex);
                }
            };

            state.Socket.BeginReceive(state.Buffer, 0, State.BufferLength, SocketFlags.None, new AsyncCallback(receiveCallback), state);
            return tcs.Task;
        }

        public sealed class State
        {
            public const string Host = "www.cnatdcu.ro";
            public const int Port = 80;
            public const int BufferLength = 1024;
            public readonly byte[] Buffer = new byte[BufferLength];
            public readonly StringBuilder Content = new StringBuilder();
            public readonly Socket Socket;

            public State(Socket socket)
            {
                Socket = socket;
            }
        }
    }
}
