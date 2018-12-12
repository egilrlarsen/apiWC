using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using apiwc.Models;

namespace apiwc.Controllers
{
    [Route("api/Words")]
    [ApiController]
    public class ValuesController : ControllerBase
    {
        // GET api/values
        [HttpGet]
        public ActionResult<IEnumerable<word>> Get(string id)
        {
           return CountWords(id);
        }


        // POST api/values
        [HttpPost]
        public ActionResult<IEnumerable<word>> Post([FromBody] string id)
        {
            return CountWords(id);  
        }


        private List<word> CountWords(string id)
        {
            Hashtable h = new Hashtable();
            Hashtable hReturn = new Hashtable();

            if (id != null)
            {
                id = id.Replace(",", "");
                id = id.Replace(".", "");

                string[] a = id.Split(" ");

                foreach (var item in a)
                {
                    if (item!="") {
                        string s = item.ToLower();
                        if (h.ContainsKey(s))
                        {
                            h[s] = (int)h[s] + 1;
                        } else {
                            h.Add(s, 1);
                        }
                    }

                }
            }

            List<word> aResult = new List<word>();


            foreach (DictionaryEntry item in h)
            {

                aResult.Add(new word() { sWord = item.Key.ToString(), count = (int)item.Value });
            }


            var r = (List<word>)aResult.OrderByDescending(w => w.count).ThenBy(w => w.sWord).ToList();

            return r;
        }




    }

}
