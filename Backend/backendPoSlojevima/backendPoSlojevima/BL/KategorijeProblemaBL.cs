using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.BL.Interfaces;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.BL
{
    public class KategorijeProblemaBL : IKategorijeProblemaBL
    {
        private readonly IKategorijeProblemaDAL _IKategorijaProblemaDAL;
        private readonly List<KategorijeProblema> kategorijaProbelma;

        public KategorijeProblemaBL (IKategorijeProblemaDAL IKategorijaProblemaDAL)
        {
            _IKategorijaProblemaDAL = IKategorijaProblemaDAL;
            kategorijaProbelma = _IKategorijaProblemaDAL.getKategorijeProblema();
        }

        public KategorijeProblema getkategorijaById(long idKategorije)
        {
            return kategorijaProbelma.FirstOrDefault(k => k.id == idKategorije);
        }

        public List<KategorijeProblema> getKategorijeByListaId(List<long> lista)
        {
            List<KategorijeProblema> listaKategorija = new List<KategorijeProblema>();
            foreach(var id in lista)
            {
                var kategorija = this.getkategorijaById(id);
                listaKategorija.Add(kategorija);
            }
            return listaKategorija;
        }

        public List<KategorijeProblema> getKategorijeProblema()
        {
            return _IKategorijaProblemaDAL.getKategorijeProblema();
        }
    }
}
