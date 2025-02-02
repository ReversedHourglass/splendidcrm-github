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

using System.Collections.Generic;

using Spring.Json;

namespace Spring.Social.Twitter.Api.Impl.Json
{
    /// <summary>
    /// JSON deserializer for saved searches. 
    /// </summary>
    /// <author>Bruno Baia</author>
    class SavedSearchDeserializer : IJsonDeserializer
    {
        private const string SAVED_SEARCH_DATE_FORMAT = "ddd MMM dd HH:mm:ss zzz yyyy";

        public object Deserialize(JsonValue value, JsonMapper mapper)
        {
            return new SavedSearch()
            {
                ID = value.GetValue<long>("id"),
                Name = value.GetValue<string>("name"),
                Query = value.GetValue<string>("query"),
                CreatedAt = JsonUtils.ToDateTime(value.GetValue<string>("created_at"), SAVED_SEARCH_DATE_FORMAT),
                Position = value.GetValue<int>("position")
            };
        }
    }
}