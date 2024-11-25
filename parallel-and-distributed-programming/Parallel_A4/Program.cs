using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Parallel_A4
{
    internal class Program
    {
        public static void Main(string[] args)
        {
            while (true)
            {
                System.Console.WriteLine("1.Callbacks\n2.Tasks\n3.AsyncAwait\n4.Exit");
                var input = Console.Read();
                switch (input)
                {
                    case '1':
                        Callbacks.MainCallbacks(args);
                        break;
                    case '2':
                        Tasks.MainTasks(args);
                        break;
                    case '3':
                        AsyncAwait.MainAsyncAwait(args);
                        break;
                    case '4':
                        return;
                    default:
                        Console.WriteLine("Wrong Input");
                        break;
                }
            }
        }
    }
}
