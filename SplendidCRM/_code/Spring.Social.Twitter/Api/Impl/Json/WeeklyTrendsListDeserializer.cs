#region License

/*
 * Copyright 2002-2012 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#endregion

// 10/20/2013 Paul.  Deprecated in version 2.0 M1.
#if false
using System.Collections.Generic;

using Spring.Json;

namespace Spring.Social.Twitter.Api.Impl.Json
{
    /// <summary>
    /// JSON deserializer for list of weekly trends. 
    /// </summary>
    /// <author>Bruno Baia</author>
    class WeeklyTrendsListDeserializer : AbstractTrendsListDeserializer
    {
        protected override string GetDateFormat()
        {
            return "yyyy-MM-dd";
        }

        protected override List<Trends> CreateTrendsList()
        {
            return new WeeklyTrendsList();
        }
    }
}
#endif
