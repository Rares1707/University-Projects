using System;
using System.Net;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace Parallel_A4
{
    public class AsyncAwait
    {
        public static async Task MainAsyncAwait(string[] args)
        {
            Console.Write("AsyncAwait started");
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

        private static async Task ConnectAsync(State state, EndPoint endpoint)
        {
            await Task.Factory.FromAsync(
                state.Socket.BeginConnect(endpoint, null, state.Socket),
                state.Socket.EndConnect
            );
        }

        private static async Task SendAsync(State state, string request)
        {
            var requestBytes = Encoding.UTF8.GetBytes(request);
            await Task.Factory.FromAsync(
                (callback, stateObject) => state.Socket.BeginSend(requestBytes, 0, requestBytes.Length, SocketFlags.None, callback, stateObject),
                state.Socket.EndSend, null
            );
        }

        private static async Task ReceiveAsync(State state)
        {
            while (true)
            {
                var bytesReceived = await Task.Factory.FromAsync<int>(
                    (callback, stateObject) => state.Socket.BeginReceive(state.Buffer, 0, State.BufferLength, SocketFlags.None, callback, stateObject),
                    state.Socket.EndReceive, null
                );

                if (bytesReceived == 0) break;

                var responseText = Encoding.UTF8.GetString(state.Buffer, 0, bytesReceived);
                state.Content.Append(responseText);
            }
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
